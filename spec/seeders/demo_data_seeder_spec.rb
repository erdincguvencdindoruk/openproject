#-- encoding: UTF-8

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe 'seeds', :with_clean_fixture do
  context 'standard edition', with_config: { edition: 'standard' } do
    it 'create the demo data' do
      expect { StandardSeeder::BasicDataSeeder.new.seed! }.not_to raise_error
      expect { AdminUserSeeder.new.seed! }.not_to raise_error
      expect { DemoDataSeeder.new.seed! }.not_to raise_error

      expect(User.where(admin: true).count).to eq 1
      expect(Project.count).to eq 2
      expect(WorkPackage.count).to eq 41
      expect(Wiki.count).to eq 2
      expect(Query.where.not(hidden: true).count).to eq 8
      expect(Query.count).to eq 24
      expect(Projects::Status.count).to eq 2
      expect(Role.pluck(:type).uniq).to match_array ['Role']

      perform_enqueued_jobs

      expect(ActionMailer::Base.deliveries)
        .to be_empty
    end
  end
end
